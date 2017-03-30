import React from 'react';
import _ from "lodash";
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

class GetStarted extends React.Component {

    constructor() {
        super();
        this.state = {
            loading: false,
            success: false
        };
    }

    getStarted(e) {
        e.preventDefault();

        this.setState({ errors: false, loading: true });

        let email = this.refs.email.value;
        this.props.getStarted(email)
            .then((res) => {
                this.setState({ success: true });
                let authToken = _.get(res, "data.getStarted.auth_token");
                localStorage.setItem("authToken", authToken);
            })
            .catch((error) => {
                let errors = _.isEmpty(error.graphQLErrors) ?
                              [{error: "Unexpected error"}] :
                              error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    }

    render() {
        const { errors, loading, success } = this.state;

        return (
            <div className="ij-get-started ui middle aligned center aligned grid">
                <div className="column">

                    <h2 className="ui icon header">
                        <div className="content">
                            Get Started
                        </div>
                    </h2>

                    <form className="ui large form" onSubmit={this.getStarted.bind(this)}>
                        <p className="ui left aligned">Getting started with Inject Detect is easy! First things first, we'll need your email address.</p>
                        <div className="ui stacked segment">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <input type="email" name="email" placeholder="E-mail address" ref="email" required/>
                                </div>
                            </div>
                            <button className={`ui large fluid ${loading ? "loading" : ""} submit brand button`} disabled={loading} type="sumbit">Get started!</button>
                        </div>
                        <div className="ui error message"></div>
                    </form>

                    { success && <div className="ui success message">You're all set!</div>}
                    { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }

                </div>
            </div>
        );
    }
};

GetStarted.propTypes = {
    getStarted: React.PropTypes.func.isRequired,
};

export default graphql(gql`
    mutation getStarted ($email: String!) {
        getStarted(email: $email) {
            id
            email
            auth_token
        }
    }
`, {
    props: ({ mutate }) => ({
        getStarted: email => mutate({ variables: { email } })
    })
})(GetStarted);
