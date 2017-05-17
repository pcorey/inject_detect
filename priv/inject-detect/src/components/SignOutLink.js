import React from "react";
import _ from "lodash";
import { Redirect } from "react-router-dom";
import { SignOutMutation } from "../graphql";
import { graphql } from "react-apollo";

class SignOutLink extends React.Component {

    state = {
        redirect: false
    }

    signOut = (e) => {
        e.preventDefault();
        this.props.signOut()
            .then(() => {
                localStorage.removeItem("authToken");
                this.setState({ redirect: true });
            });
    }

    render() {
        if (this.state.redirect) {
            return ( <Redirect to="/"/> );
        }
        return (
            <a href="#"
               className="item"
               onClick={this.signOut}>{this.props.children}</a>
        );
    }
};

SignOutLink.propTypes = {
    signOut: React.PropTypes.func.isRequired
};

export default graphql(SignOutMutation, {
    name: "signOut"
})(SignOutLink);
