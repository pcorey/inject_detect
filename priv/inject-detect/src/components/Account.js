import Charges from './Charges';
import AccountSubscription from './AccountSubscription';
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
                    {/* <h3 className="ui sub header">Billing:</h3> */}
                    {user.active
                        ? user.stripeToken
                              ? <div>
                                    <p className="instructions">
                                        Your account is active, and we're currently monitoring all of your applications for NoSQL Injection attacks. The payment method we have on file for your account is a card ending in
                                        {' '}
                                        <strong>{user.stripeToken.card.last4}</strong>
                                        , expiring on
                                        {' '}
                                        <strong>
                                            {user.stripeToken.card.expMonth}/{user.stripeToken.card.expYear}
                                        </strong>
                                        . Feel free to update your payment method below.
                                    </p>
                                    <AccountSubscription />
                                </div>
                              : <p className="instructions">
                                    You haven't added a payment method to your account. Be sure to add a payment method before your trail runs out to avoid interruptions in service. Read about
                                    {' '}
                                    <a href="http://www.injectdetect.com/pricing/">our pricing and billing</a>
                                    {' '}
                                    for more information.
                                </p>
                        : <div>
                              <p className="instructions">
                                  Your account is decativated. Inject Detect is no longer monitoring your applications for NoSQL Injection attacks. To re-activate your account,
                                  {' '}
                                  <strong>update your payment method</strong>
                                  {' '}
                                  below.
                              </p>
                              <AccountSubscription />
                          </div>}
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
