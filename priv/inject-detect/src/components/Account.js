import Charges from './Charges';
import Moment from 'react-moment';
import UpdatePaymentMethodModal from './UpdatePaymentMethodModal';
import DeactivateAccountModal from './DeactivateAccountModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form } from 'semantic-ui-react';
import { commas } from './pretty';
import { graphql } from 'react-apollo';

class Account extends React.Component {
    initProgress() {
        window.$('.ui.progress').progress();
    }

    componentDidMount() {
        this.initProgress();
    }

    componentDidUpdate() {
        this.initProgress();
    }

    render() {
        let { loading, user } = this.props.data;

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
                    {user.active
                        ? user.stripeToken
                              ? <p className="instructions">
                                    Your account is active, and we're actively monitoring all of your applications for NoSQL Injection attacks! The payment method we have on file for your account is a card ending in
                                    {' '}
                                    <strong>{user.stripeToken.card.last4}</strong>
                                    , expiring on
                                    {' '}
                                    <strong>{user.stripeToken.card.expMonth}/{user.stripeToken.card.expYear}</strong>
                                    . Feel free to update your payment method below.
                                    <br /><br />
                                    The current billing amount for your month-to-date usage is
                                    {' '}
                                    <strong>${(_.get(user, 'subscription.amount') / 100).toFixed(2)}</strong>
                                    {' '}
                                    and is scheduled for automatic payment on
                                    {' '}
                                    <strong>
                                        <Moment format="MM/DD">
                                            {_.get(user, 'subscription.currentPeriodEnd') * 1000}
                                        </Moment>
                                    </strong>
                                    .
                                </p>
                              : <p className="instructions">No card.</p>
                        : <p className="instructions">
                              Your account is decativated. Inject Detect is no longer monitoring your applications for NoSQL Injection attacks. To re-activate your account,
                              {' '}
                              <strong>update your payment method</strong>
                              {' '}
                              below.
                          </p>}
                </div>

                <div className="sixteen wide column" style={{ marginTop: 0 }}>
                    <div className="ui grid">
                        <div
                            className="sixteen wide column section"
                            style={{ marginTop: 0, marginLeft: 'auto', marginRight: 'auto' }}
                        >
                            <UpdatePaymentMethodModal user={user} />
                        </div>

                        {user.stripeToken
                            ? <div
                                  className="sixteen wide column section"
                                  style={{ marginTop: 0, marginLeft: 'auto', marginRight: 'auto' }}
                              >
                                  <DeactivateAccountModal user={user} />
                              </div>
                            : null}
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
            email
            active
            locked
            subscribed
            subscription {
                id
                currentPeriodEnd
                amount
            }
            stripeToken {
                card {
                    last4
                    expMonth
                    expYear
                }
            }
        }
    }
`)(Account);
