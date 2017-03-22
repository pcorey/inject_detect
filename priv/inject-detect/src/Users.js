import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

function GetStarted({mutate, userId, onGetStarted}) {
    return (
            <button onClick={() => mutate({ variables: { email: `foo+${Math.random()}@email.com` }}) && onGetStarted()}>
            Get started
        </button>
    )
}

const GetStartedWrapped = graphql(gql`
    mutation ($email: String!) {
        getStarted(email: $email) {
            id
        }
    }
`)(GetStarted);

// The data prop, which is provided by the wrapper below contains,
// a `loading` key while the query is in flight and posts when it is ready
function Users({ data: { loading, users, refetch } }) {
    if (loading) {
        return <div>Loading</div>;
    } else {
        let onGetStarted = () => refetch();
        return (
            <div>
                <ul>
                    {users.map(user => <li key={user.id}>{user.email}</li>)}
                </ul>
                <GetStartedWrapped onGetStarted={onGetStarted}/>
            </div>
        );
    }
}

// The `graphql` wrapper executes a GraphQL query and makes the results
// available on the `data` prop of the wrapped component (PostList here)
export default graphql(gql`
    query {
        users {
            id
            email
        }
    }
`, {
    // options: { pollInterval: 1000 },
})(Users);
