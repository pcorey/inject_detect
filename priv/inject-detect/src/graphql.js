import gql from "graphql-tag";

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
                collection,
                queriedAt,
                query,
                type
            }
            expectedQueries {
                collection,
                query,
                type
            }
        }
    }
`;

export const GetStartedMutation = gql`
    mutation getStarted ($email: String!,
                         $applicationName: String!,
                         $applicationSize: String!,
                         $agreedToTos: Boolean) {
        getStarted(email: $email,
                   applicationName: $applicationName,
                   applicationSize: $applicationSize,
                   agreedToTos: $agreedToTos) {
            authToken
            ${UserProps}
        }
    }
`;

export const TurnOnTrainingModeMutation = gql`
    mutation turnOnTrainingMode ($applicationId: String!) {
        turnOnTrainingMode(applicationId: $applicationId) {
            trainingMode
        }
    }
`;

export const TurnOffTrainingModeMutation = gql`
    mutation turnOffTrainingMode ($applicationId: String!) {
        turnOffTrainingMode(applicationId: $applicationId) {
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
