import OneTimePurchase from './OneTimePurchase';
import RecurringPurchase from './RecurringPurchase';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form } from 'semantic-ui-react';
import { commas } from './pretty';
import { graphql } from 'react-apollo';

class Account extends React.Component {
    state = {
        oneTimePurchase: true
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
    }

    componentWillUpdate() {
        if (!this.props.data.loading) {
            this.initStripeElements();
        }
    }

    setOneTimePurchase = oneTimePurchase => {
        return e => {
            this.setState({ oneTimePurchase });
        };
    };

    render() {
        let { loading, user } = this.props.data;
        let { oneTimePurchase } = this.state;

        if (loading) {
            return <div className="ui active loader" />;
        }

        console.log(user);

        return (
            <div className="ij-dashboard ui stackable grid">
                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Account settings
                    </h1>
                </div>

                <div className="section" style={{ marginTop: 0 }}>
                    <h3 className="ui sub header">User information:</h3>
                    <p className="instructions">
                        Your email address is <strong>{user.email}</strong>.
                    </p>
                </div>

                <div className="section" style={{ width: '100%' }}>
                    <h3 className="ui sub header">Credits and Payments:</h3>
                    <p className="instructions">
                        <span>
                            Your account current has <strong>{commas(user.credits)}</strong> credits remaining.{' '}
                        </span>
                        {user.refill
                            ? <span>
                                  Your account is configured to automatically purchase an additional
                                  {' '}
                                  <strong>{commas(user.refillAmount)}</strong>
                                  {' '}
                                  credits once it reaches
                                  {' '}
                                  <strong>{commas(user.refillTrigger)}</strong>
                                  {' '}
                                  remaining credits.
                                  {' '}
                              </span>
                            : <span>
                                  <strong>
                                      Your account is not configured to automatically purchase additional credits.{' '}
                                  </strong>
                              </span>}
                    </p>

                    <p>Recent purchases:</p>
                    {_.map(user.charges, charge => {
                        return <p key={charge.id}>{charge.id}: {charge.amount} - {charge.description}</p>;
                    })}

                    <div className="ui segment">
                        <Form>
                            <Form.Radio
                                label="Recurring purchase"
                                onChange={this.setOneTimePurchase(false)}
                                checked={!oneTimePurchase}
                            />
                            <Form.Radio
                                label="One time purchase"
                                onChange={this.setOneTimePurchase(true)}
                                checked={oneTimePurchase}
                            />
                            {oneTimePurchase ? <OneTimePurchase user={user} /> : <RecurringPurchase user={user} />}
                        </Form>
                    </div>

                </div>

            </div>
        );
    }
}

export default graphql(gql`
    query {
        user {
            id
            credits
            refill
            refillTrigger
            refillAmount
            email
            charges {
                id
                amount
                created
                description
            }
        }
    }
`)(Account);
