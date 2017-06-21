import ConfirmModal from './ConfirmModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button } from 'semantic-ui-react';
import { graphql } from 'react-apollo';

class TurnOffRefill extends React.Component {
    state = {
        loading: false,
        success: false
    };

    turnOffRefill = () => {
        this.setState({ loading: true });
        this.props
            .turnOffRefill(this.props.user.id)
            .then(res => {
                this.setState({
                    success: true
                });
            })
            .catch(error => {
                let errors = _.isEmpty(error.graphQLErrors) ? [{ error: 'Unexpected error' }] : error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    };

    render() {
        let { user } = this.props;
        let { loading } = this.state;

        return (
            <ConfirmModal
                header="Turn off automatic refills?"
                text={`Your account is configured to purchase an additional ${Number(user.refillAmount).toLocaleString()} whenever you have ${Number(user.refillTrigger).toLocaleString()} or fewer credits remaining. Would you like to cancel this recurring refill?`}
                positive="Turn off automatic refills"
                callback={this.turnOffRefill}
                trigger={
                    <Button
                        className="brand"
                        fluid
                        icon="remove"
                        size="big"
                        content="Turn off automatic refills"
                        labelPosition="right"
                        loading={loading}
                    />
                }
            />
        );
    }
}

export default graphql(
    gql`
    mutation turnOffRefill ($userId: String!) {
        turnOffRefill(userId: $userId) {
            id
            refill
        }
    }
`,
    {
        props: ({ mutate }) => ({
            turnOffRefill: userId =>
                mutate({
                    variables: { userId }
                })
        })
    }
)(TurnOffRefill);
