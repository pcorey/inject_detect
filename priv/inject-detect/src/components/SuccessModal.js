import React from 'react';
import _ from 'lodash';
import { Button, Modal } from 'semantic-ui-react';

class SuccessModal extends React.Component {
    state = {
        open: true
    };

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    click = () => {
        this.close();
        if (this.props.callback) {
            this.props.callback();
        }
    };

    render() {
        const { open } = this.state;

        return (
            <Modal
                size="small"
                className="confirm-modal"
                closeIcon="close"
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>{this.props.header}</Modal.Header>
                <div className="content">
                    <p className="instructions">{this.props.text}</p>
                </div>
                <div className="actions">
                    <Button positive onClick={this.click}>
                        {this.props.positive || 'Ok'}
                    </Button>
                </div>
            </Modal>
        );
    }
}

export default SuccessModal;
