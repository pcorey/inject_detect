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
        console.log('user', user);

        if (_.get(user, 'invoice.startingBalance') > 0) {
            return (
                <p className="instructions">
                    So far this month, we've processed
                    {' '}
                    <strong>{(_.get(user, 'invoice.total') * 10).toLocaleString()}</strong>
                    {' '}
                    queries made by your applications. On
                    {' '}
                    <strong><Moment date={_.get(user, 'invoice.periodEnd') * 1000} format="MMMM DD, YYYY" /></strong>
                    {' '}
                    we'll be charging
                    {' '}
                    <strong>${(_.get(user, 'invoice.total') / 100).toFixed(2)}</strong>
                    {' '}
                    against your account balance of
                    {' '}
                    <strong>${(user.invoice.startingBalance / 100).toFixed(2)}</strong>
                    . Account usage is updated hourly.
                </p>
            );
        }

        return (
            <p className="instructions">
                So far this month, we've processed
                {' '}
                <strong>{(_.get(user, 'invoice.total') * 10).toLocaleString()}</strong>
                {' '}
                queries made by your applications. On
                {' '}
                <strong><Moment date={_.get(user, 'invoice.periodEnd') * 1000} format="MMMM DD, YYYY" /></strong>
                {' '}
                we'll be charging
                {' '}
                <strong>${(_.get(user, 'invoice.total') / 100).toFixed(2)}</strong>
                {' '}
                to your account. Account usage is updated hourly.
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
                periodEnd
                startingBalance
                total
            }
        }
    }
`)(AccountSubscription);
