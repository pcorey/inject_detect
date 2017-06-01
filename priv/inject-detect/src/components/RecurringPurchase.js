import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form } from 'semantic-ui-react';
import { graphql } from 'react-apollo';

class RecurringPurchase extends React.Component {
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
    }

    componentDidMount() {
        this.initStripeElements();
    }

    render() {
        return (
            <div>
                <Form.Select
                    label="When my account has ..."
                    options={[
                        { key: 1000, text: '1,000 credits remaining', value: 1000 },
                        { key: 10000, text: '10,000 credits remaining', value: 10000 },
                        { key: 100000, text: '100,000 credits remaining', value: 100000 },
                        { key: 1000000, text: '1,000,000 credits remaining', value: 1000000 }
                    ]}
                    placeholder="Refill trigger"
                />
                <Form.Select
                    label="Buy an additional ..."
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
                <Button className="primary">Purchase credits</Button>
            </div>
        );
    }
}

export default RecurringPurchase;
/* export default graphql(gql`
 *     mutation {
 *         buyCredits($userId: String) {
 *             id
 *             credits
 *             refill
 *             refillTrigger
 *             refillAmount
 *             email
 *             stripeToken {
 *                 id
 *                 card {
 *                     expMonth
 *                     expYear
 *                     last4
 *                 }
 *             }
 *         }
 *     }
 * `)(RecurringPurchase);*/
