import React from "react";
import _ from "lodash";
import { Button, Icon, Modal } from "semantic-ui-react";

class Confirm extends React.Component {

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
        let { children, prompt, positive, negative, header } = this.props;

        return (
            <Modal size="small"
                   closeIcon="close"
                   trigger={children}
                   open={open}
                   onOpen={this.open}
                   onClose={this.close}>
                <Modal.Header>{header}</Modal.Header>
                <Modal.Content image>
                    <Modal.Description>
                        <p>{prompt}</p>

                        { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }
                    </Modal.Description>
                </Modal.Content>
                <Modal.Actions>
                    <Button onClick={this.close}>
                        <Icon name="remove" /> {negative}
                    </Button>
                    <Button color="green" loading={loading} onClick={this.callback}>
                        <Icon name="checkmark" /> {positive}
                    </Button>
                </Modal.Actions>
            </Modal>
        );
    }

};

export default Confirm;
