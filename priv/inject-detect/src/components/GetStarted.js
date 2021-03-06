import React from 'react';
import _ from 'lodash';
import { GetStartedMutation } from '../graphql';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class GetStarted extends React.Component {
    state = {
        loading: false,
        success: false
    };

    createUser(e) {
        e.preventDefault();

        this.setState({ errors: false, loading: true });

        let email = this.state.email;
        let applicationName = this.state.applicationName;
        let agreedToTos = this.refs.agreedToTos.checked;
        let referralCode = this.refs.referralCode.value;

        return this.props
            .createUser(email, applicationName, referralCode, agreedToTos)
            .then(res => {
                this.setState({ success: true });
                let authToken = _.get(res, 'data.createUser.authToken');
                localStorage.setItem('authToken', authToken);
                setTimeout(() => this.setState({ redirect: true }), 1000);
            })
            .catch(error => {
                console.log('error', JSON.stringify(error));
                let errors = _.isEmpty(error.graphQLErrors) ? [{ error: 'Unexpected error' }] : error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    }

    changeEmail = e => {
        this.setState({ email: e.target.value });
    };

    changeApplicationName = e => {
        this.setState({ applicationName: e.target.value });
    };

    render() {
        const { email, applicationName, errors, loading, redirect, success } = this.state;

        if (redirect) {
            return <Redirect to="/" />;
        }

        return (
            <div className="ij-get-started ui middle stackable aligned center aligned grid">
                <div className="sixteen wide column">
                    <h1 className="ui header">Get Started</h1>
                </div>
                <div className="eight wide column">
                    <p className="instructions" style={{ marginTop: 0, textAlign: 'left' }}>
                        <strong>Getting started with Inject Detect is easy!</strong>
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        First things first, we'll need your email address and your application's name. We use
                        {' '}
                        <a
                            target="_blank"
                            href="http://www.east5th.co/blog/2017/04/24/passwordless-authentication-with-phoenix-tokens/"
                        >
                            passwordless authentication{' '}
                        </a>
                        {' '}
                        to keep your account secure and to improve your experience.
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        When you sign up, we'll automatically give you an account balance of
                        {' '}
                        <strong>$10.00</strong>
                        , so you can try out Inject Detect with no commitment. Enter a referral code if you have one!
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        Lastly, please be sure to read through our
                        {' '}
                        <a href="http://www.injectdetect.com/terms/">terms of service</a>
                        {' '}
                        before signing up.
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        Let's get started!
                    </p>
                </div>
                <div className="eight wide center aligned column">
                    <form className="ui large form" onSubmit={this.createUser.bind(this)}>
                        <div className="ui left aligned stacked segment">
                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="user icon" />
                                    <input
                                        type="email"
                                        name="email"
                                        placeholder="E-mail address"
                                        value={email}
                                        onChange={this.changeEmail}
                                        required
                                    />
                                </div>
                            </div>

                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="server icon" />
                                    <input
                                        type="text"
                                        name="applicationName"
                                        placeholder="Application name"
                                        value={applicationName}
                                        onChange={this.changeApplicationName}
                                        required
                                    />
                                </div>
                            </div>

                            <hr style={{ border: '0', borderBottom: '1px solid #ddd', margin: '1em 2em' }} />

                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="heart icon" />
                                    <input
                                        type="text"
                                        name="referralCode"
                                        placeholder="Referral code"
                                        ref="referralCode"
                                    />
                                </div>
                            </div>

                            <div className="field">
                                <div className="ui checkbox">
                                    <input
                                        type="checkbox"
                                        id="agreedToTos"
                                        name="agreedToTos"
                                        ref="agreedToTos"
                                        required
                                    />
                                    {/* TODO: Write TOS */}
                                    <label htmlFor="agreedToTos">
                                        I agree to <a href="http://www.injectdetect.com/terms/">the terms</a>.
                                    </label>
                                </div>
                            </div>

                            <button
                                className={`ui large fluid ${loading ? 'loading' : ''} submit brand button`}
                                disabled={loading}
                                type="sumbit"
                            >
                                Get started!
                            </button>

                        </div>
                        <div className="ui error message" />
                    </form>

                    {success && <div className="ui success message">You're all set!</div>}
                    {errors && errors.map(({ error }) => <div key={error} className="ui error message">{error}</div>)}

                    <div className="ui message">
                        Already have an account? <a href="/sign-in">Sign in!</a>
                    </div>

                </div>
            </div>
        );
    }
}

GetStarted.propTypes = {
    getStarted: React.PropTypes.func.isRequired
};

export default graphql(GetStartedMutation, {
    props: ({ mutate }) => ({
        createUser: (email, applicationName, referralCode, agreedToTos) =>
            mutate({
                variables: {
                    email,
                    applicationName,
                    agreedToTos,
                    referralCode
                }
            })
    })
})(GetStarted);
