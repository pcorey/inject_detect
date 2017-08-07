import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Button, Checkbox, Loader, Form, Icon, Input, Modal } from 'semantic-ui-react';
import { PrismCode } from 'react-prism';
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
                                Add the following configuration block to your Meteor project's settings.json file. Read more about application configuration in our
                                {' '}
                                <a href="http://www.injectdetect.com/education/getting-started">Getting Started</a>
                                {' '}
                                guide.
                            </p>
                            <p
                                style={{
                                    overflow: 'auto',
                                    fontSize: '0.85em',
                                    backgroundColor: '#f8f8f8',
                                    padding: '1em'
                                }}
                            >
                                <PrismCode className="structure language-javascript">{`"inject-detect": {
    "secret": "${application.token}"
}`}</PrismCode>
                            </p>
                            <p>
                                <Button
                                    style={{ display: 'block', margin: '0 auto' }}
                                    onClick={this.regenerateApplicationToken}
                                >
                                    Regenerate Application Secret
                                </Button>
                            </p>

                            <hr />

                            <p className="instructions" style={{ marginTop: 0 }}>
                                Removing this application will delete all records about the application, including all settings, expected queries, and unexpected queries from Inject Detect. Removing application is non-reversible.
                            </p>

                            {user.applications.length > 1
                                ? <Form.Field style={{ textAlign: 'center' }}>
                                      <Button className="brand" onClick={this.removeApplication}>
                                          Remove application
                                      </Button>
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
