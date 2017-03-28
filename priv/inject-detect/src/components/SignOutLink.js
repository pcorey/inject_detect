import React from 'react';
import _ from "lodash";
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

class SignOutLink extends React.Component {

    constructor() {
        super();
        this.state = {
            loading: false,
            success: false
        };
    }

    signOut(e) {
        e.preventDefault();

        this.setState({ loading: true });

        this.props.signOut()
            .then(() => {
                localStorage.removeItem("authToken")
                this.setState({ success: true });
            })
            .catch((error) => {
                console.error(error);
            })
            .then(() => {
                this.setState({ loading: false });
            });
    }

    render() {
        const { loading, success } = this.state;
        return (
            <a href="#" className="item" onClick={this.signOut.bind(this)}>{this.props.children}</a>
        );
    }
};

SignOutLink.propTypes = {
    signOut: React.PropTypes.func.isRequired
};

export default graphql(gql`
    mutation {
        signOut {
            id
        }
    }
`, {
    name: "signOut",
    options: ({ params }) => {
        return {
            refetchQueries: [{
                query: gql`
                    query {
                        user {
                            id
                            email
                        }
                    }
                `
            }]
        }
    }
})(SignOutLink);
