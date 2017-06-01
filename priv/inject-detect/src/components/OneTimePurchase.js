import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form } from 'semantic-ui-react';
import { graphql } from 'react-apollo';

class OneTimePurchase extends React.Component {
    state = {
        success: false,
        stripeLoaded: false
    };

    style = {
        base: {
            fontFamily: "Lato,'Helvetica Neue',Arial,Helvetica,sans-serif",
            '::placeholder': {
                color: '#ccc'
            }
        }
    };

    initStripeElements() {
        const stripe = window.Stripe(_.get(process.env, 'REACT_APP_STRIPE_SECRET'));
        const elements = stripe.elements();
        const card = elements.create('card', { style: this.style });
        card.mount('#card-element');
        this.stripe = stripe;
        this.elements = elements;
        this.card = card;
        this.setState({ stripeLoaded: true });
    }

    componentDidMount() {
        if (!this.state.stripeLoaded) {
            this.initStripeElements();
        }
    }

    oneTimePurchase = e => {
        e.preventDefault();
        const { user } = this.props;
        this.stripe
            .createToken(this.card)
            .then(result => {
                if (result.error) {
                    throw { graphQLErrors: [{ error: result.error.message }] };
                } else {
                    return result.token;
                }
            })
            .then(stripeToken => ({
                id: stripeToken.id,
                card: {
                    id: _.get(stripeToken, 'card.id'),
                    expMonth: _.get(stripeToken, 'card.exp_month'),
                    expYear: _.get(stripeToken, 'card.exp_year'),
                    last4: _.get(stripeToken, 'card.last4')
                }
            }))
            .then(stripeToken => this.props.oneTimePurchase(user.id, 10000, stripeToken))
            .then(res => {
                this.setState({ success: true });
            })
            .catch(error => {
                console.log('error', JSON.stringify(error));
                let errors = _.isEmpty(error.graphQLErrors) ? [{ error: 'Unexpected error' }] : error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    };

    render() {
        const { errors, success } = this.state;
        return (
            <div>
                <Form.Select
                    label="Credits to purchase:"
                    options={[
                        { key: 50000, text: '50,000 credits for $5.00', value: 50000 },
                        { key: 100000, text: '100,000 credits for $10.00', value: 100000 },
                        { key: 200000, text: '200,000 credits for $20.00', value: 200000 },
                        { key: 500000, text: '500,000 credits for $50.00', value: 500000 },
                        { key: 1000000, text: '1,000,000 credits for $100.00', value: 1000000 },
                        { key: 10000000, text: '10,000,000 credits for $1000.00', value: 10000000 }
                    ]}
                    placeholder="Credits to purchase"
                />
                <div className="field">
                    <label>Payment information:</label>
                    <div
                        id="card-element"
                        style={{
                            border: '1px solid rgba(34,36,38,.15)',
                            borderRadius: '.28571429rem',
                            padding: '.67857143em 1em'
                        }}
                    />
                </div>
                <Button className="primary" onClick={this.oneTimePurchase}>Purchase credits</Button>

                {success && <div className="ui success message">You're all set!</div>}
                {errors && errors.map(({ error }) => <div key={error} className="ui error message">{error}</div>)}

            </div>
        );
    }
}

export default graphql(
    gql`
    mutation oneTimePurchase($userId: String, $credits: Int, $stripeToken: StripeTokenInput) {
        oneTimePurchase(userId: $userId, credits: $credits, stripeToken: $stripeToken) {
            id
            credits
            refill
            refillTrigger
            refillAmount
            email
            stripeToken {
                id
                card {
                    expMonth
                    expYear
                    last4
                }
            }
        }
    }
`,
    {
        props: ({ mutate }) => ({
            oneTimePurchase: (userId, credits, stripeToken) =>
                mutate({
                    variables: {
                        userId,
                        credits,
                        stripeToken
                    }
                })
        })
    }
)(OneTimePurchase);
