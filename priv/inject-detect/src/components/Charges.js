import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form } from 'semantic-ui-react';
import { graphql } from 'react-apollo';
import Moment from 'react-moment';

class Charges extends React.Component {
    render() {
        let { loading, user } = this.props.data;

        if (loading) {
            return <div className="ui active loader" />;
        }

        return (
            <div className="ij-chages">
                {_.map(user.charges, charge => {
                    return (
                        <p key={charge.id} className="instructions">
                            <Moment format="YYYY/MM/DD hh:mm a" date={new Date(charge.created * 1000)} /> -
                            $
                            {(charge.amount / 100).toFixed(2)}
                        </p>
                    );
                })}
            </div>
        );
    }
}

export default graphql(gql`
    query {
        user {
            id
            charges {
                id
                amount
                created
                description
            }
        }
    }
`)(Charges);
