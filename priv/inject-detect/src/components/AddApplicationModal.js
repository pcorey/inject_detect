import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { Modal } from "semantic-ui-react";
import { Redirect } from "react-router-dom";
import { graphql } from "react-apollo";

class AddApplicationModal extends React.Component {

    state = {
        open: false,
        loading: false,
        success: false
    }

    open = () => this.setState({ open: true })
    close = () => this.setState({ open: false })

    addApplication = (e) => {
        e.preventDefault();

        this.setState({ errors: false, success: false, loading: true });

        let userId = this.props.user.id;
        let name = this.refs.name.value || undefined;
        let size = this.refs.size.value || undefined;
        this.props.addApplication(userId, name, size)
            .then((res) => {
                this.setState({
                    success: true,
                    applicationId: _.get(res, "data.addApplication.id")
                });
            })
            .catch((error) => {
                let errors = _.isEmpty(error.graphQLErrors) ?
                              [{error: "Unexpected error"}] :
                              error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    }

    render() {
        const { user } = this.props;
        const { errors, loading, open, success, applicationId } = this.state;

        if (applicationId) {
            return (<Redirect to={`/application/${applicationId}`}/>);
        }

        return (
            <Modal size="small"
                   className="add-application-modal"
                   closeIcon="close"
                   trigger={<a href="#" className="item"><i className="plus icon"/>Add Application</a>}
                   open={open}
                   onOpen={this.open}
                   onClose={this.close}>
                <Modal.Header>Add a new application</Modal.Header>
                <div className="content">
                    <form className="ui large form">
                        <p className="information">All we need to get started is the name of your new application, and a rough estimate of its size. The application name helps you track down where queries are being made, and the application size helps us give better token usage estimates.</p>
                        <div className="inline fields">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="server icon"></i>
                                    <input type="text" name="name" placeholder="Application name" ref="name" required/>
                                </div>
                            </div>
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <div className="ui selection dropdown">
                                        <input type="hidden" name="size" ref="size"/>
                                        <i className="dropdown icon"></i>
                                        <div className="default text">Application Size</div>
                                        <div className="menu">
                                            <div className="item" data-value="small">Small</div>
                                            <div className="item" data-value="medium">Medium</div>
                                            <div className="item" data-value="large">Large</div>
                                            <div className="item" data-value="extra_large">Extra Large</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>

                    { success && <div className="ui success message">Application added!</div>}
                    { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }

                </div>
                <div className="actions">
                    <div className="ui deny button">
                        Cancel
                    </div>
                    <button onClick={this.addApplication} className={`ui positive right labeled icon button ${loading ? "loading" : ""}`}>
                        Add application
                        <i className="checkmark icon"></i>
                    </button>
                </div>
            </Modal>
        );
    }
};

export default graphql(gql`
    mutation addApplication ($userId: String!,
                             $applicationName: String!,
                             $applicationSize: String!) {
        addApplication(userId: $userId,
                       applicationName: $applicationName,
                       applicationSize: $applicationSize) {
            id
        }
    }
`, {
    props: ({ mutate }) => ({
        addApplication: (userId, applicationName, applicationSize) => mutate({
            variables: { userId, applicationName, applicationSize }
        })
    })
})(AddApplicationModal);
