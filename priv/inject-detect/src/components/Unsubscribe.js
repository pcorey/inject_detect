import React from 'react';
import _ from 'lodash';
import { UnsubscribeMutation } from '../graphql';
import { Redirect } from 'react-router-dom';
import { graphql } from 'react-apollo';

class Unsubscribe extends React.Component {
    state = {
        loading: false,
        success: false,
        redirect: false
    };

    componentDidMount() {
        let token = _.get(this.props, 'match.params.token');
        if (token) {
            this.verifyRequestedToken(token);
        }
    }

    verifyRequestedToken(token) {
        this.setState({ errors: false, loading: true });

        this.props
            .verify(token)
            .then(res => {
                this.setState({ success: true });
                let authToken = _.get(res, 'data.verifyRequestedToken.authToken');
                localStorage.setItem('authToken', authToken);
                setTimeout(() => this.setState({ redirect: true }), 1000);
            })
            .catch(error => {
                let errors = _.isEmpty(error.graphQLErrors) ? [{ error: 'Unexpected error' }] : error.graphQLErrors;
                this.setState({ errors });
            })
            .then(() => {
                this.setState({ loading: false });
            });
    }

    render() {
        const { errors, success, redirect } = this.state;

        if (redirect) {
            return <Redirect to="/" />;
        }

        return (
            <div className="ij-verify-requested-token ui middle aligned center aligned grid">
                <div className="column">

                    <h2 className="ui icon header">
                        <h1 className="ui header">
                            Unsubscribing...
                        </h1>
                    </h2>

                    {success &&
                        <div className="ui success message">
                            You've been unsubscribed all Inject Detect emails!
                        </div>}
                    {errors &&
                        errors.map(({ error }) => (
                            <div key={error} className="ui error message">
                                {error}
                            </div>
                        ))}

                </div>
            </div>
        );
    }
}

Unsubscribe.propTypes = {
    verify: React.PropTypes.func.isRequired
};

export default graphql(UnsubscribeMutation, {
    props: ({ mutate }) => ({
        verify: token => mutate({ variables: { token } })
    })
})(Unsubscribe);
