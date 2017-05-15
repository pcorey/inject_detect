import React from "react";
import StripeCheckout from 'react-stripe-checkout';
import _ from "lodash";
import gql from "graphql-tag";
import { Button } from "semantic-ui-react";
import { commas } from "./pretty";
import { graphql } from "react-apollo";

class Account extends React.Component {

    state = {
        token: undefined
    }

    initProgress() {
        window.$('.ui.progress').progress();
    }

    componentDidMount() {
        this.initProgress();
    }

    componentDidUpdate() {
        this.initProgress();
    }

    onToken = (token) => {
        console.log("token", token)
        this.setState({ token });
        /* fetch('/save-stripe-token', {
         *     method: 'POST',
         *     body: JSON.stringify(token),
         * }).then(response => {
         *     response.json().then(data => {
         *         alert(`We are in business, ${data.email}`);
         *     });
         * });*/
    }

    render() {
        let { loading, user } = this.props.data;

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }

        let unexpectedQueries = _.chain(user.applications)
                                 .map("unexpectedQueries")
                                 .flatten()
                                 .sortBy("queriedAt")
                                 .reverse()
                                 .value();

        return (
            <div className="ij-dashboard ui">
                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Account settings
                    </h1>
                </div>

                <div className="section" style={{marginTop: 0}}>
                    <h3 className="ui sub header">User information:</h3>
                    <p className="instructions">
                        Your email address is <strong>{user.email}</strong>.
                    </p>
                </div>

                <div className="section" style={{width: "100%"}}>
                    <h3 className="ui sub header">Billing:</h3>
                    <p className="instructions">
                        <span>Your account current has <strong>{commas(user.credits)}</strong> credits remaining. </span>
                        {
                            user.refill ? (
                                <span>Your account is configured to purchase an additional <strong>{commas(user.refillAmount)}</strong> credits once it reaches <strong>{commas(user.refillTrigger)}</strong> remaining credits. </span>
                            ) : (
                                <span>Your account is not configured to purchase additional credits. </span>
                            )
                        }
                    </p>
                    <p className="instructions">
                        {
                            this.state.token ? this.state.token.card.last4 : null
                        }
                    </p>
                    <StripeCheckout name="Inject Detect"
                                    email={user.email}
                                    panelLabel="Update"
                                    description="Recurring payment information."
                                    stripeKey="pk_test_9Eb30CotIL95wj3aeTkTVDrL"
                                    token={this.onToken}>
                        <Button primary>Update your payment information.</Button>
                    </StripeCheckout>
                </div>
            </div>
        );
    }
};

export default graphql(gql`
    query {
        user {
            id
            credits
            refill
            refillTrigger
            refillAmount
            email
        }
    }
`)(Account);
