import ApolloClient, { createNetworkInterface } from 'apollo-client';
import CurrentUser from "./CurrentUser";
import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import Users from "./Users";
import _ from "lodash";
import gql from 'graphql-tag';
import logo from './logo.svg';
import { ApolloProvider, graphql } from 'react-apollo';

import Layout from "./components/Layout";
import "./styles/index.styl";

const networkInterface = createNetworkInterface({
    uri: _.get(process.env, "REACT_APP_GRAPHQL_URL"),
    dataIdFromObject: object => object.id
});

networkInterface.use([{
    applyMiddleware(req, next) {
        let token = localStorage.getItem("authToken");
        if (token) {
            req.options.headers = _.extend(req.options.headers, {
                authorization: `Bearer ${token}`
            });
        }
        next();
    }
}]);

networkInterface.useAfter([{
    applyAfterware({ response }, next) {
        console.log(response);
        if (response.status === 403) {
            console.log("Logged out")
            localStorage.removeItem("authToken");
            if (client) {
                client.query({
                    query: gql`
                        query {
                            current_user {
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

const client = new ApolloClient({
    networkInterface,
});


ReactDOM.render(
    (
        <ApolloProvider client={client}>
            <Layout>
                <p>Hi</p>
            </Layout>
        </ApolloProvider>
    ),
    document.getElementById('root')
);
