import React from 'react';
import _ from 'lodash';
import { Button, Modal } from 'semantic-ui-react';

class ConfirmModal extends React.Component {
    state = {
        open: false
    };

    open = () => this.setState({ open: true });
    close = () => this.setState({ open: false });

    render() {
        const { open } = this.state;

        return (
            <Modal
                size="small"
                className="confirm-modal"
                closeIcon="close"
                trigger={this.props.trigger}
                open={open}
                onOpen={this.open}
                onClose={this.close}
            >
                <Modal.Header>{this.props.header}</Modal.Header>
                <div className="content">
                    <p className="instructions">{this.props.text}</p>
                </div>
                <div className="actions">
                    <Button onClick={this.close}>
                        {this.props.negative || 'Cancel'}
                    </Button>
                    <Button positive onClick={this.props.callback}>
                        {this.props.positive || 'Ok'}
                    </Button>
                </div>
            </Modal>
        );
    }
}

export default ConfirmModal;
