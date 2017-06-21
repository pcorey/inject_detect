import Charges from './Charges';
import ConfigureAutomaticRefillsModal from './ConfigureAutomaticRefillsModal';
import OneTimePurchase from './OneTimePurchase';
import OneTimePurchaseModal from './OneTimePurchaseModal';
import React from 'react';
import RecurringPurchase from './RecurringPurchase';
import TurnOffRefill from './TurnOffRefill';
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

    initProgress() {
        window.$('.ui.progress').progress();
    }

    componentDidMount() {
        this.initProgress();
    }

    componentDidUpdate() {
        this.initProgress();
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

        return (
            <div className="ij-dashboard ui stackable grid">
                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Account settings
                    </h1>
                </div>

                <div className="sixteen wide column section" style={{ marginTop: 0 }}>
                    {/* <h3 className="ui sub header">Credits and Payments:</h3> */}
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
                                  remaining credits using a card ending in
                                  {' '}
                                  <strong>{user.stripeToken.card.last4}</strong>
                                  .
                                  {' '}
                              </span>
                            : <span>
                                  <strong>
                                      Your account is not configured to automatically purchase additional credits.{' '}
                                  </strong>
                              </span>}
                    </p>
                    <div
                        className="ui indicating progress"
                        data-percent={Math.min(user.credits / user.refillAmount, 1) * 100}
                    >
                        <div className="bar" />
                    </div>
                </div>

                <hr style={{ border: 0, borderBottom: '1px solid #ddd', width: '75%', margin: '1em auto 2em' }} />

                <div className="sixteen wide column" style={{ marginTop: 0 }}>
                    <div className="ui grid">
                        <div
                            className="sixteen wide column section"
                            style={{ marginTop: 0, marginLeft: 'auto', marginRight: 'auto' }}
                        >
                            <OneTimePurchaseModal user={user} />
                        </div>

                        {user.refill
                            ? <div
                                  className="sixteen wide column section"
                                  style={{ marginTop: 0, marginLeft: 'auto', marginRight: 'auto' }}
                              >
                                  <TurnOffRefill user={user} />
                              </div>
                            : <div
                                  className="sixteen wide column section"
                                  style={{ marginTop: 0, marginLeft: 'auto', marginRight: 'auto' }}
                              >
                                  <ConfigureAutomaticRefillsModal user={user} />
                              </div>}

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
            stripeToken {
                card {
                    last4
                }
            }
        }
    }
`)(Account);
