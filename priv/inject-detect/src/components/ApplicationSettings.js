import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Checkbox, Loader, Form, Icon, Input, Modal } from 'semantic-ui-react';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class ApplicationSettings extends React.Component {
    state = {
        open: false,
        loading: false,
        errors: undefined
    };

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    toggleTrainingMode = () => {
        this.props.toggleTrainingMode(this.props.application.id);
    };

    toggleAlerting = () => {
        this.props.toggleAlerting(this.props.application.id);
    };

    regenerateApplicationToken = () => {
        this.props.regenerateApplicationToken(this.props.application.id);
    };

    removeApplication = e => {
        e.preventDefault();
        this.props.removeApplication(this.props.application.id).then(() => {
            this.setState({ redirect: true });
        });
    };

    callback = () => {
        if (this.props.callback) {
            this.setState({ loading: true });
            this.props
                .callback()
                .then(() => this.close())
                .catch(error => {
                    let errors = _.isEmpty(error.graphQLErrors) ? [{ error: 'Unexpected error' }] : error.graphQLErrors;
                    this.setState({ errors });
                })
                .then(() => this.setState({ loading: false }));
        } else {
            this.close();
        }
    };

    render() {
        let { errors, loading, open, redirect } = this.state;
        let { application } = this.props;
        let { user } = this.props.data;

        if (this.props.data.loading) {
            return <Loader />;
        }

        if (redirect) {
            return <Redirect to="/" />;
        }

        return (
            <Modal
                size="small"
                className="application-settings"
                closeIcon="close"
                trigger={
                    <button className="ui icon button" style={{ margin: '0' }}><i className="settings icon" /></button>
                }
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>{application.name} settings</Modal.Header>
                <Modal.Content image>
                    <Modal.Description>
                        <Form>
                            <p className="instructions" style={{ marginTop: 0 }}>
                                Applications in
                                {' '}
                                <strong>training mode</strong>
                                {' '}
                                will automatically mark every incoming query as an "expected query". Applications that are
                                {' '}
                                <strong>alerting</strong>
                                {' '}
                                will send email alerts whenever an "unexpected query" is detected.
                            </p>
                            <Form.Field>
                                <Checkbox
                                    defaultChecked={application.trainingMode}
                                    label="Training mode"
                                    onChange={this.toggleTrainingMode}
                                />
                            </Form.Field>

                            <Form.Field>
                                <Checkbox
                                    defaultChecked={application.alerting}
                                    label="Alerting"
                                    onChange={this.toggleAlerting}
                                />
                            </Form.Field>

                            <hr />

                            <p className="instructions" style={{ marginTop: 0 }}>
                                Your
                                {' '}
                                <strong>application secret</strong>
                                {' '}
                                should be given to your Meteor plugin and is used to identify your application as it sends queries to Inject Detect:
                            </p>

                            <Form.Field>
                                <Input
                                    readOnly
                                    type="text"
                                    value={application.token}
                                    icon={
                                        <Icon name="refresh" circular link onClick={this.regenerateApplicationToken} />
                                    }
                                />
                            </Form.Field>

                            <hr />

                            <p className="instructions" style={{ marginTop: 0 }}>
                                Removing this application will delete all records about the application, including all settings, expected queries, and unexpected queries from Inject Detect. Removing application is non-reversible.
                            </p>

                            {user.applications.length > 1
                                ? <Form.Field style={{ textAlign: 'center' }}>
                                      <Button onClick={this.removeApplication}>Remove application</Button>
                                  </Form.Field>
                                : null}
                        </Form>

                        {errors &&
                            errors.map(({ error }) => <div key={error} className="ui error message">{error}</div>)}
                    </Modal.Description>
                </Modal.Content>
            </Modal>
        );
    }
}

const ToggleTrainingMode = graphql(
    gql`
    mutation toggleTrainingMode ($application_id: String!) {
        toggleTrainingMode(application_id: $application_id) {
            id
            trainingMode
        }
    }
`,
    {
        props: ({ mutate }) => ({
            toggleTrainingMode: application_id =>
                mutate({
                    variables: { application_id }
                })
        })
    }
);

const ToggleAlerting = graphql(
    gql`
    mutation toggleAlerting ($application_id: String!) {
        toggleAlerting (application_id: $application_id) {
            id
            alerting
        }
    }
`,
    {
        props: ({ mutate }) => ({
            toggleAlerting: application_id =>
                mutate({
                    variables: { application_id }
                })
        })
    }
);

const RegenerateApplicationToken = graphql(
    gql`
    mutation regenerateApplicationToken ($application_id: String!) {
        regenerateApplicationToken (application_id: $application_id) {
            id
            token
        }
    }
`,
    {
        props: ({ mutate }) => ({
            regenerateApplicationToken: application_id =>
                mutate({
                    variables: { application_id }
                })
        })
    }
);

const RemoveApplication = graphql(
    gql`
    mutation removeApplication ($application_id: String!) {
        removeApplication (application_id: $application_id) {
            id
            applications {
                name
            }
        }
    }
`,
    {
        props: ({ mutate }) => ({
            removeApplication: application_id =>
                mutate({
                    variables: { application_id }
                })
        })
    }
);

const Query = graphql(
    gql`
    query applications {
        user {
            id
            applications {
                id
            }
        }
    }
`,
    {
        options: props => {
            return {
                fetchPolicy: 'cache-and-network'
            };
        }
    }
);

export default RemoveApplication(
    RegenerateApplicationToken(ToggleTrainingMode(ToggleAlerting(Query(ApplicationSettings))))
);
