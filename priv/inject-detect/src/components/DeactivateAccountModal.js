import ConfirmModal from './ConfirmModal';
import SuccessModal from './SuccessModal';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Modal } from 'semantic-ui-react';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class DeactivateAccountModal extends React.Component {
    state = {
        open: false,
        loading: false,
        success: false
    };

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    deactivateAccount = () => {
        this.setState({ errors: false, success: false, loading: true });

        this.props
            .deactivateAccount(this.props.user.id)
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
                    header="Deactivate Account"
                    text={`We've successfully deactivated your account.`}
                    positive="Return to account"
                    callback={() => this.setState({ success: false })}
                />
            );
        }

        return (
            <Modal
                size="small"
                className="deactivate-account-modal"
                closeIcon="close"
                trigger={
                    <Button
                        fluid
                        icon="exclamation"
                        size="big"
                        className="brand"
                        content="Deactivate account"
                        labelPosition="right"
                    />
                }
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>Deactivate account</Modal.Header>
                <div className="content">
                    <form className="ui large form">
                        <div>
                            <p className="instructions">
                                Are you sure you want to deactivate your account? Once deactivated, we'll immediately stop monitoring the applications in your account for unexpected queries.
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
                        header="Deactivate account?"
                        text={'Are you sure you want to deactivate your account?'}
                        positive="Deactivate account"
                        callback={this.deactivateAccount}
                        trigger={
                            <Button
                                className="brand"
                                loading={loading}
                                icon="exclamation"
                                labelPosition="right"
                                content="Deactivate account"
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
    mutation deactivateAccount ($userId: String!) {
        deactivateAccount (userId: $userId) {
            id
            active
        }
    }
`,
    {
        props: ({ mutate }) => ({
            deactivateAccount: (userId, stripeToken) =>
                mutate({
                    variables: { userId, stripeToken }
                })
        })
    }
)(DeactivateAccountModal);
