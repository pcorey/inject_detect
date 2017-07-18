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

        // TODO: Better queries calculation here
        return (
            <p className="instructions">
                So far this month, we've processed
                {' '}
                <strong>{(_.get(user, 'invoice.total') * 10).toLocaleString()}</strong>
                {' '}
                queries made by your applications. On
                {' '}
                <strong><Moment date={_.get(user, 'invoice.periodEnding') * 1000} format="MMMM DD, YYYY" /></strong>
                {' '}
                we'll be charging
                {' '}
                <strong>${(_.get(user, 'invoice.amountDue') / 100).toFixed(2)}</strong>
                {' '}
                to your account
                {_.get(user, 'invoice.endingBalance')
                    ? <span>
                          , leaving your account balance at
                          {' '}
                          <strong>$${(user.invoice.endingBalance / 100).toFixed(2)}</strong>
                          .
                      </span>
                    : <span>.</span>}
            </p>
        );
    }
}

export default graphql(gql`
    query {
        user {
            id
            invoice {
                id
                total
                amountDue
                periodEnd
                endingBalance
            }
        }
    }
`)(AccountSubscription);
