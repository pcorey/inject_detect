import ConfirmModal from './ConfirmModal';
import SuccessModal from './SuccessModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Modal } from 'semantic-ui-react';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class RemovePaymentMethodModal extends React.Component {
    state = {
        open: false,
        loading: false,
        success: false
    };

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    removePaymentMethod = () => {
        this.setState({ errors: false, success: false, loading: true });

        let userId = this.props.user.id;

        this.stripe
            .createToken(this.card)
            .then(result => {
                if (result.error) {
                    throw { graphQLErrors: [{ error: result.error.message }] };
                } else {
                    return result.token;
                }
            })
            .then(stripeToken => ({
                id: stripeToken.id,
                card: {
                    id: _.get(stripeToken, 'card.id'),
                    expMonth: _.get(stripeToken, 'card.exp_month'),
                    expYear: _.get(stripeToken, 'card.exp_year'),
                    last4: _.get(stripeToken, 'card.last4')
                }
            }))
            .then(stripeToken => this.props.removePaymentMethod(userId, stripeToken))
            .then(res => {
                this.setState({
                    success: true,
                    open: false
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
        const { errors, loading, open, success, applicationId } = this.state;

        if (applicationId) {
            return <Redirect to={`/application/${applicationId}`} />;
        }

        if (success) {
            return (
                <SuccessModal
                    header="Automatic payment cancelled!"
                    text={`We've successfully cancelled your automatic payment.`}
                    positive="Return to account"
                    callback={() => this.setState({ success: false })}
                />
            );
        }

        return (
            <Modal
                size="small"
                className="remove-payment-method-modal"
                closeIcon="close"
                trigger={
                    <Button
                        fluid
                        icon="exclamation"
                        size="big"
                        className="brand"
                        content="Cancel automatic payment"
                        labelPosition="right"
                    />
                }
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>Cancel automatic payment</Modal.Header>
                <div className="content">
                    <form className="ui large form">
                        <div>
                            <p className="instructions">
                                Are you sure you want to cancel your current automatic payment? Without adding a new payment method before your next monthly invoice, your account may be locked.
                            </p>
                        </div>

                        {errors &&
                            errors.map(({ error }) => <div key={error} className="ui error message">{error}</div>)}

                    </form>

                </div>
                <div className="actions">
                    <Button onClick={this.close} disabled={loading}>
                        Cancel
                    </Button>
                    <ConfirmModal
                        header="Cancel automatic payment?"
                        text={`Are you sure you want to cancel your automatic payment?`}
                        positive="Cancel automatic payment"
                        callback={this.removePaymentMethod}
                        trigger={
                            <Button
                                positive
                                loading={loading}
                                icon="exclamation"
                                labelPosition="right"
                                content="Cancel automatic payment"
                            />
                        }
                    />
                </div>
            </Modal>
        );
    }
}

export default graphql(
    gql`
    mutation removePaymentMethod ($userId: String!) {
        removePaymentMethod (userId: $userId) {
            id
            stripeToken {
                card {
                    last4
                }
            }
        }
    }
`,
    {
        props: ({ mutate }) => ({
            removePaymentMethod: (userId, stripeToken) =>
                mutate({
                    variables: { userId, stripeToken }
                })
        })
    }
)(RemovePaymentMethodModal);
