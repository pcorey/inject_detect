import ApolloClient, { createNetworkInterface } from "apollo-client";
import gql from "graphql-tag";
import _ from "lodash";

const networkInterface = createNetworkInterface({
    uri: _.get(process.env, "REACT_APP_GRAPHQL_URL")
});

export const client = new ApolloClient({
    networkInterface,
    dataIdFromObject: object => object.id
});

networkInterface.use([{
    applyMiddleware(req, next) {
        let authToken = localStorage.getItem("authToken");
        if (authToken) {
            req.options.headers = _.extend(req.options.headers, {
                authorization: `Bearer ${authToken}`
            });
        }
        next();
    }
}]);

networkInterface.useAfter([{
    applyAfterware({ response }, next) {
        if (response.status === 403) {
            localStorage.removeItem("authToken");
            if (client) {
                client.query({
                    query: gql`
                        query {
                            user {
                                id
                                email
                            }
                        }
                    `
                });
            }
        }
        next();
    }
}]);

