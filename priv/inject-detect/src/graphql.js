import gql from 'graphql-tag';

export const UserProps = `
    id
    email
    applications {
        id
        name
    }
`;

export const UserQuery = gql`
    query user {
        user {
            ${UserProps}
        }
    }
`;

export const ApplicationQuery = gql`
    query application($id: String!) {
        application(id: $id) {
            id
            name
            token
            trainingMode
            alerting
            unexpectedQueries {
                id,
                collection,
                queriedAt,
                query,
                type
            }
            expectedQueries {
                id,
                collection,
                queriedAt,
                query,
                type
            }
        }
    }
`;

export const GetStartedMutation = gql`
    mutation getStarted ($email: String!,
                         $applicationName: String!,
                         $agreedToTos: Boolean,
                         $stripeToken: StripeToken) {
        getStarted(email: $email,
                   applicationName: $applicationName,
                   agreedToTos: $agreedToTos,
                   stripeToken: $stripeToken) {
            authToken
            ${UserProps}
        }
    }
`;

export const ToggleTrainingModeMutation = gql`
    mutation toggleTrainingMode ($applicationId: String!) {
        toggleTrainingMode(applicationId: $applicationId) {
            id
            trainingMode
        }
    }
`;

export const RequestSignInTokenMutation = gql`
    mutation ($email: String!) {
        requestSignInToken(email: $email) {
            id
        }
    }
`;

export const SignOutMutation = gql`
    mutation signOut {
        signOut {
            id
        }
    }
`;

export const VerifyRequestedTokenMutation = gql`
    mutation verifyRequestedToken ($token: String!) {
        verifyRequestedToken(token: $token) {
            authToken
            ${UserProps}
        }
    }
`;
