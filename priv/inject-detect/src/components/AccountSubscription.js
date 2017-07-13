import Moment from 'react-moment';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

class AccountSubscription extends React.Component {
    render() {
        let { loading, user } = this.props.data;

        if (loading) {
            return <p className="instructions">&nbsp;</p>;
        }

        return (
            <p className="instructions">
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
        );
    }
}

export default graphql(gql`
    query {
        user {
            id
            subscription {
                id
                currentPeriodEnd
                amount
            }
        }
    }
`)(AccountSubscription);
