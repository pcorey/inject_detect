import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

function CurrentUser({ data: { loading, user } }) {
    if (loading) {
        return <div>Loading</div>;
    } else {
        if (user) {
            return (<p>{user.id} ({user.email})</p>);
        }
        else {
            return (<p>Logged out</p>);
        }
    }
}

// The `graphql` wrapper executes a GraphQL query and makes the results
// available on the `data` prop of the wrapped component (PostList here)
export default graphql(gql`
    query {
        user {
            id
            email
        }
    }
`, {
    // options: { pollInterval: 1000 },
})(CurrentUser);
