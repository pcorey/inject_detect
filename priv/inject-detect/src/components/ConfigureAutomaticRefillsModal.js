import ConfirmModal from './ConfirmModal';
import SuccessModal from './SuccessModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Form, Modal } from 'semantic-ui-react';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class ConfigureAutomaticRefillsModal extends React.Component {
    state = {
        open: false,
        loading: false,
        success: false,
        credits: undefined,
        creditPrice: undefined
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

    open = () => this.setState({ open: true, refillTrigger: undefined, refillAmount: undefined });
    close = () => this.setState({ open: false });

    configureAutomaticRefills = () => {
        this.setState({ errors: false, success: false, loading: true });

        let userId = this.props.user.id;
        let refillAmount = this.state.refillAmount;
        let refillTrigger = this.state.refillTrigger;

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
            .then(stripeToken => this.props.configureAutomaticRefills(userId, refillAmount, refillTrigger, stripeToken))
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

    changeTrigger = (e, select) => {
        this.setState({
            refillTrigger: select.value
        });
    };

    changeAmount = (e, select) => {
        this.setState({
            refillAmount: select.value,
            creditPrice: _.find(select.options, o => o.value == select.value).text
        });
    };

    render() {
        const { user } = this.props;
        const { refillAmount, refillTrigger, creditPrice, errors, loading, open, success, applicationId } = this.state;

        if (applicationId) {
            return <Redirect to={`/application/${applicationId}`} />;
        }

        if (success) {
            return (
                <SuccessModal
                    header="Automatic Refill Configured!"
                    text={`We've gone ahead and configured your account to purchase an additional ${creditPrice} once you have ${Number(refillTrigger).toLocaleString()} credits remaining in your account.`}
                    positive="Return to account"
                    callback={() => this.setState({ success: false })}
                />
            );
        }

        return (
            <Modal
                size="small"
                className="configure-automatic-refills"
                closeIcon="close"
                trigger={
                    <Button
                        primary
                        fluid
                        icon="repeat"
                        size="big"
                        content="Configure automatic refills"
                        labelPosition="right"
                    />
                }
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>Configure Automatic Refills</Modal.Header>
                <div className="content">
                    <form className="ui large form">
                        <div>
                            <p className="instructions">
                                Your account can be configured to automatically purchase additional credits whenever your amount of available credits drops to a certain threshold.
                            </p>
                            <Form.Select
                                label="When my account has:"
                                value={refillTrigger}
                                onChange={this.changeTrigger}
                                options={[
                                    { key: 1000, text: '1,000 remaining credits', value: 1000 },
                                    { key: 2000, text: '2,000 remaining credits', value: 2000 },
                                    { key: 5000, text: '5,000 remaining credits', value: 5000 },
                                    { key: 10000, text: '10,000 remaining credits', value: 10000 },
                                    { key: 100000, text: '100,000 remaining credits', value: 100000 }
                                ]}
                                placeholder="When my account has..."
                            />
                            <Form.Select
                                label="Purchase an additional:"
                                value={refillAmount}
                                onChange={this.changeAmount}
                                options={[
                                    { key: 100000, text: '100,000 credits for $10.00', value: 100000 },
                                    { key: 200000, text: '200,000 credits for $20.00', value: 200000 },
                                    { key: 500000, text: '500,000 credits for $50.00', value: 500000 },
                                    { key: 1000000, text: '1,000,000 credits for $100.00', value: 1000000 },
                                    { key: 10000000, text: '10,000,000 credits for $1000.00', value: 10000000 }
                                ]}
                                placeholder="Purchase an additional..."
                            />
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
                        header="Configure Automatic Refills?"
                        text={`Are you sure you want to configure your account to purchase ${creditPrice} once you have ${Number(refillTrigger).toLocaleString()} credits remaining?`}
                        positive="Configure automatic refills"
                        callback={this.configureAutomaticRefills}
                        trigger={
                            <Button
                                positive
                                loading={loading}
                                icon="repeat"
                                labelPosition="right"
                                content="Configure automatic refills"
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
    mutation configureAutomaticRefills ($userId: String!, $refillAmount: Int!, $refillTrigger: Int!, $stripeToken: StripeTokenInput!) {
        setStripeToken(userId: $userId, stripeToken: $stripeToken) {
            id
            refillAmount
        }
        setRefillAmount(userId: $userId, refillAmount: $refillAmount) {
            id
            refillAmount
        }
        setRefillTrigger(userId: $userId, refillTrigger: $refillTrigger) {
            id
            refillTrigger
        }
        turnOnRefill(userId: $userId) {
            id
            refill
        }
    }
`,
    {
        props: ({ mutate }) => ({
            configureAutomaticRefills: (userId, refillAmount, refillTrigger, stripeToken) =>
                mutate({
                    variables: { userId, refillAmount, refillTrigger, stripeToken }
                })
        })
    }
)(ConfigureAutomaticRefillsModal);
