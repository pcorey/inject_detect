import React from "react";
import _ from "lodash";
import { GetStartedMutation } from "../graphql";
import { graphql } from "react-apollo";

class GetStarted extends React.Component {

    state = {
        loading: false,
        success: false
    }

    getStarted(e) {
        e.preventDefault();

        this.setState({ errors: false, loading: true });

        let email = this.refs.email.value;
        let application_name = this.refs.application_name.value;
        let application_size = this.refs.application_size.value;
        let agreed_to_tos = this.refs.agreed_to_tos.checked;

        this.props.getStarted(email,
                              application_name,
                              application_size,
                              agreed_to_tos)
               .then((res) => {
                   this.setState({ success: true });
                   let authToken = _.get(res, "data.getStarted.auth_token");
                   localStorage.setItem("authToken", authToken);
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
            <div className="ij-get-started ui middle aligned center aligned grid">
                <div className="eight wide left aligned column">

                    <h2 className="ui icon header">
                        <div className="content">
                            Get Started
                        </div>
                    </h2>

                    <form className="ui large form" onSubmit={this.getStarted.bind(this)}>
                        <p className="ui left aligned">Getting started with Inject Detect is easy! First things first, we'll need your email address.</p>
                        <div className="ui stacked segment">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon"></i>
                                    <input type="email" name="email" placeholder="E-mail address" ref="email" required/>
                                </div>
                            </div>

                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="server icon"></i>
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

                            <div className="field">
                                <div className="ui checkbox">
                                    <input type="checkbox" id="agreed_to_tos" name="agreed_to_tos" ref="agreed_to_tos" required/>
                                    <label htmlFor="agreed_to_tos">I agree to the terms.</label>
                                </div>
                            </div>

                            <button className={`ui large fluid ${loading ? "loading" : ""} submit brand button`} disabled={loading} type="sumbit">Get started!</button>
                        </div>
                        <div className="ui error message"></div>
                    </form>

                    { success && <div className="ui success message">You're all set!</div>}
                    { errors && errors.map(({ error }) => (<div key={error} className="ui error message">{error}</div>)) }

                </div>
            </div>
        );
    }
};

GetStarted.propTypes = {
    getStarted: React.PropTypes.func.isRequired,
};

export default graphql(GetStartedMutation, {
    props: ({ mutate }) => ({
        getStarted: (email,
                     applicationName,
                     applicationSize,
                     agreedToTos) => mutate({
                         variables: {
                             email,
                             applicationName,
                             applicationSize,
                             agreedToTos
                         }
                     })
    })
})(GetStarted);
