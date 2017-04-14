import React from "react";
import _ from "lodash";
import { RequestSignInTokenMutation } from "../graphql";
import { graphql } from "react-apollo";

class SignIn extends React.Component {

    state = {
        loading: false,
        success: false
    }

    requestSignInToken(e) {
        e.preventDefault();

        this.setState({ errors: false, success: false, loading: true });

        let email = this.refs.email.value;
        this.props.request(email)
            .then(() => {
                this.setState({ success: true });
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
        const { errors, loading, success } = this.state;

        return (
            <div className="ij-signin ui middle aligned center aligned grid">
                <div className="column">

                    <h2 className="ui icon header">
                        <div className="content">
                            Request a Sign-in Link
                        </div>
                    </h2>

                    <form className="ui large form" onSubmit={this.requestSignInToken.bind(this)}>
                        <p className="ui left aligned">Enter your email address and we'll send you a magic link that will sign you in instantly!</p>
                        <div className="ui stacked segment">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <input type="email" name="email" placeholder="E-mail address" ref="email" required/>
                                </div>
                            </div>
                            <button className={`ui large fluid ${loading ? "loading" : ""} submit brand button`} disabled={loading} type="sumbit">Send link</button>
                        </div>
                    </form>

                    { success && <div className="ui success message">We've sent you a sign-in link. Check your email!</div>}
                    { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }

                    <div className="ui message">
                        Don't have an account? <a href="/get-started">Get started!</a>
                    </div>

                </div>
            </div>
        );
    }
};

SignIn.propTypes = {
    request: React.PropTypes.func.isRequired,
};

export default graphql(RequestSignInTokenMutation, {
    props: ({ mutate }) => ({
        request: email => mutate({ variables: { email } })
    })
})(SignIn);
