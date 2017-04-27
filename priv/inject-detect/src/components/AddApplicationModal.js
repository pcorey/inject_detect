import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { graphql } from "react-apollo";

class AddApplicationModal extends React.Component {

    addApplication(e) {
        e.preventDefault();
        this.props.addApplication()
        /* .then(() => {
         *     localStorage.removeItem("authToken");
         * });*/
    }

    render() {
        return (
            <div className="ui small modal add-application-modal">
                <i className="close icon"></i>
                <div className="header">
                    Add a new application
                </div>
                <div className="image content">
                    <form className="ui large form" onSubmit={this.addApplication.bind(this)}>
                        <p className="information">All we need to get started is the name of your new application, and a rough estimate of its size. The application name helps you track down where queries are being made, and the application size helps us give better token usage estimates.</p>
                        <div className="inline fields">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <input type="text" name="application_name" placeholder="Application name" ref="application_name" required/>
                                </div>
                            </div>
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <div className="ui selection dropdown">
                                        <input type="hidden" name="application_size" ref="application_size"/>
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
                </div>
                <div className="actions">
                    <div className="ui deny button">
                        Cancel
                    </div>
                    <div className="ui positive right labeled icon button">
                        Add application
                        <i className="checkmark icon"></i>
                    </div>
                </div>
            </div>
        );
    }
};

export default graphql(gql`
    mutation signOut {
        signOut {
            id
        }
    }
`, {
    name: "addApplication"
})(AddApplicationModal);
