import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

function CurrentUser({ data: { loading, currentUser } }) {
    if (loading) {
        return <div>Loading</div>;
    } else {
        if (currentUser) {
            return (<p>{currentUser.id} ({currentUser.email})</p>);
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
        currentUser {
            id
            email
        }
    }
`, {
    // options: { pollInterval: 1000 },
})(CurrentUser);
