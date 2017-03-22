import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

function GetStarted({mutate, userId}) {
    return (
        <button onClick={() => mutate({ variables: { email: `foo+${Math.random()}@email.com` }})}>
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
function Users({ data: { loading, users } }) {
    if (loading) {
        return <div>Loading</div>;
    } else {
        console.log(users)
        return (
            <div>
                <ul>
                    {users.map(user => <li key={user.id}>{user.email}</li>)}
                </ul>
                <GetStartedWrapped/>
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
`)(Users);
