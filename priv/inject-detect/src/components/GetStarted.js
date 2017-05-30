import React from 'react';
import _ from 'lodash';
import { GetStartedMutation } from '../graphql';
import { graphql } from 'react-apollo';

class GetStarted extends React.Component {
    state = {
        loading: false,
        success: false
    };

    style = {
        base: {
            fontFamily: "Lato,'Helvetica Neue',Arial,Helvetica,sans-serif",
            '::placeholder': {
                color: '#ccc'
            }
        }
    };

    initStripeElements() {
        const stripe = window.Stripe(_.get(process.env, 'REACT_APP_STRIPE_SECRET'));
        const elements = stripe.elements();
        const card = elements.create('card', { style: this.style });
        card.mount('#card-element');
        this.stripe = stripe;
        this.elements = elements;
        this.card = card;
    }

    componentDidMount() {
        this.initStripeElements();
    }

    getStarted(e) {
        e.preventDefault();

        this.setState({ errors: false, loading: true });

        let email = this.state.email;
        let applicationName = this.state.applicationName;
        let agreedToTos = this.refs.agreedToTos.checked;

        this.stripe
            .createToken(this.card)
            .then(result => {
                if (result.error) {
                    throw { graphQLErrors: [{ error: result.error.message }] };
                } else {
                    return result.token;
                }
            })
            .then(stripeToken => ({
                id: stripeToken.id,
                card: {
                    id: _.get(stripeToken, 'card.id'),
                    expMonth: _.get(stripeToken, 'card.exp_month'),
                    expYear: _.get(stripeToken, 'card.exp_year'),
                    last4: _.get(stripeToken, 'card.last4')
                }
            }))
            .then(stripeToken => this.props.getStarted(email, applicationName, agreedToTos, stripeToken))
            .then(res => {
                this.setState({ success: true });
                let authToken = _.get(res, 'data.getStarted.auth_token');
                localStorage.setItem('authToken', authToken);
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
        const { email, applicationName, errors, loading, success } = this.state;

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
                        First things first, we'll need your
                        {' '}
                        email address
                        and your
                        {' '}
                        application's name
                        . We use
                        {' '}
                        <a href="#">passwordless authentication </a>
                        to keep your account secure and to improve your experience.
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        Next, we'll set up your payment information. Inject Detect uses an
                        {' '}
                        <a href="#">on demand billing system</a>
                        {' '}
                        which means you'll only pay for the services you use.{' '}
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        Lastly, please be sure to read through our <a href="#">terms of service</a> before signing up.
                    </p>
                    <p className="instructions" style={{ textAlign: 'left' }}>
                        Let's get started!
                    </p>
                </div>
                <div className="eight wide center aligned column">
                    <form className="ui large form" onSubmit={this.getStarted.bind(this)}>
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
                                <div
                                    id="card-element"
                                    style={{
                                        border: '1px solid rgba(34,36,38,.15)',
                                        borderRadius: '.28571429rem',
                                        padding: '.67857143em 1em'
                                    }}
                                />
                            </div>

                            <div className="field">
                                <div className="ui left icon input">
                                    <i className="heart icon" />
                                    <input type="text" name="coupon" placeholder="Coupon code" ref="coupon" />
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
                                    <label htmlFor="agreedToTos">I agree to <a href="#">the terms</a>.</label>
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
        getStarted: (email, applicationName, agreedToTos, stripeToken) =>
            mutate({
                variables: {
                    email,
                    applicationName,
                    agreedToTos,
                    stripeToken
                }
            })
    })
})(GetStarted);
