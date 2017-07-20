import ConfirmModal from './ConfirmModal';
import SuccessModal from './SuccessModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Modal } from 'semantic-ui-react';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class UpdatePaymentMethodModal extends React.Component {
    state = {
        open: false,
        loading: false,
        success: false
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

    componentDidUpdate(prevProps, prevState) {
        if (!prevState.open && this.state.open) {
            this.initStripeElements();
        }
    }

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    updatePaymentMethod = () => {
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
            .then(stripeToken => this.props.updatePaymentMethod(userId, stripeToken))
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
                    header="Payment Method Updated!"
                    text={`We've successfully updated your payment method.`}
                    positive="Return to account"
                    callback={() => this.setState({ success: false })}
                />
            );
        }

        return (
            <Modal
                size="small"
                className="update-paymnet-method-modal"
                closeIcon="close"
                trigger={
                    <Button
                        primary
                        fluid
                        icon="dollar"
                        size="big"
                        content="Update payment method"
                        labelPosition="right"
                    />
                }
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>Update payment method</Modal.Header>
                <div className="content">
                    <form className="ui large form">
                        <div>
                            <p className="instructions">
                                Enter a new payment method. This payment method will be used to automatically pay upcoming monthly invoices, along with any past due invoices.
                            </p>
                            <div className="field">
                                <label>Payment information:</label>
                                <div
                                    id="card-element"
                                    style={{
                                        border: '1px solid rgba(34,36,38,.15)',
                                        borderRadius: '.28571429rem',
                                        padding: '.67857143em 1em'
                                    }}
                                />
                            </div>
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
                        header="Update payment method?"
                        text={`Are you sure you want to update your payment method?`}
                        positive="Update"
                        callback={this.updatePaymentMethod}
                        trigger={
                            <Button
                                positive
                                loading={loading}
                                icon="dollar"
                                labelPosition="right"
                                content="Update payment method"
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
    mutation updatePaymentMethod ($userId: String!, $stripeToken: StripeTokenInput!) {
        updatePaymentMethod (userId: $userId, stripeToken: $stripeToken) {
            id
            stripeToken {
                card {
                    last4
                    expMonth
                    expYear
                }
            }
        }
    }
`,
    {
        props: ({ mutate }) => ({
            updatePaymentMethod: (userId, stripeToken) =>
                mutate({
                    variables: { userId, stripeToken }
                })
        })
    }
)(UpdatePaymentMethodModal);
