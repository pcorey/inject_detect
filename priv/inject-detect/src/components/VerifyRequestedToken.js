import React from "react";
import _ from "lodash";
import { VerifyRequestedTokenMutation } from "../graphql";
import { Redirect } from "react-router-dom";
import { graphql } from "react-apollo";

class VerifyRequestedToken extends React.Component {

    state = {
        loading: false,
        success: false,
        redirect: false
    }

    componentDidMount() {
        let token = _.get(this.props, "match.params.token");
        if (token) {
            this.verifyRequestedToken(token);
        }
    }

    verifyRequestedToken(token) {
        this.setState({ errors: false, loading: true });

        this.props.verify(token)
            .then((res) => {
                this.setState({ success: true });
                let authToken = _.get(res, "data.verifyRequestedToken.authToken");
                localStorage.setItem("authToken", authToken);
                setTimeout(() => this.setState({ redirect: true }), 1000);
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
        const { errors, success, redirect } = this.state;

        if (redirect) {
            return (<Redirect to="/"/>);
        }

        return (
            <div className="ij-verify-requested-token ui middle aligned center aligned grid">
                <div className="column">

                    <h2 className="ui icon header">
                        <div className="content">
                            Verifying Requested Token...
                        </div>
                    </h2>

                    { success &&
                      <div className="ui success message">
                          Verified! We're redirecting you to your dashboard...
                      </div> }
                    { errors &&
                      errors.map(({ error }) => (
                          <div key={error} className="ui error message">
                              {error}
                          </div>)
                      ) }

                </div>
            </div>
        );
    }
};

VerifyRequestedToken.propTypes = {
    verify: React.PropTypes.func.isRequired
};

export default graphql(VerifyRequestedTokenMutation, {
    props: ({ mutate }) => ({
        verify: token => mutate({ variables: { token } })
    })
})(VerifyRequestedToken);
