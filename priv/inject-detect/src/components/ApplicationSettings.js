import React from "react";
import _ from "lodash";
import { Button, Checkbox, Form, Icon, Input, Modal } from "semantic-ui-react";

class ApplicationSettings extends React.Component {

    state = {
        open: false,
        loading: false,
        errors: undefined
    }

    open = () => this.setState({ open: true })
    close = () => this.setState({ open: false })

    callback = () => {
        if (this.props.callback) {
            this.setState({ loading: true });
            this.props.callback()
                .then(() => this.close())
                .catch(error => {
                    let errors = _.isEmpty(error.graphQLErrors) ?
                                 [{error: "Unexpected error"}] :
                                 error.graphQLErrors;
                    this.setState({ errors });
                })
                .then(() => this.setState({ loading: false }))
        }
        else {
            this.close();
        }
    }

    render() {
        let { errors, loading, open } = this.state;
        let { application } = this.props;

        return (
            <Modal size="small"
                   closeIcon="close"
                   trigger={<button className="ui icon button"><i className="settings icon"></i></button>}
                   open={open}
                   onOpen={this.open}
                   onClose={this.close}>
                <Modal.Header>{application.name} settings</Modal.Header>
                <Modal.Content image>
                    <Modal.Description>
                        <Form>
                            <p className="instructions" style={{marginTop: 0}}>Applications in <strong>training mode</strong> will automatically mark every incoming query as an "expected query". Applications that are <strong>alerting</strong> will send email alerts whenever an "unexpected query" is detected.</p>
                            <Form.Field>
                                <Checkbox toggle defaultChecked={application.trainingMode} label="Training mode"/>
                            </Form.Field>

                            <Form.Field>
                                <Checkbox toggle defaultChecked={application.alerting} label="Alerting" />
                            </Form.Field>

                            <Form.Field>
                                <Input type="password" label="Application secret:" value={application.token}/>
                            </Form.Field>
                            <Form.Field>
                                <Button icon="eye" content="Show secret"/>
                                <Button icon="refresh" content="Generate new secret"/>
                            </Form.Field>
                        </Form>

                        { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }
                    </Modal.Description>
                </Modal.Content>
                <Modal.Actions>
                    <Button onClick={this.close}>
                        <Icon name="remove" /> Done
                    </Button>
                </Modal.Actions>
            </Modal>
        );
    }

};

export default ApplicationSettings;
