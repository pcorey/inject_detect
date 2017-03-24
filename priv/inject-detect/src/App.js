import './App.css';
import ApolloClient, { createNetworkInterface } from 'apollo-client';
import React, { Component } from 'react';
import logo from './logo.svg';
import { ApolloProvider, graphql } from 'react-apollo';
import Users from "./Users";
import CurrentUser from "./CurrentUser";
import _ from "lodash";
import gql from 'graphql-tag';
import Layout from "./components/Layout";

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

class App extends Component {
    render() {
        return (
            <ApolloProvider client={client}>
                <div className="App">
                    <Layout>
                        <div className="App-header">
                        <img src={logo} className="App-logo" alt="logo" />
                        <h2>Welcome to React</h2>
                        <CurrentUser/>
                        </div>
                        <p className="App-intro">
                        To get started, edit <code>src/App.js</code> and save to reload.
                        </p>
                        <Users/>
                    </Layout>
                </div>
            </ApolloProvider>
        );
    }
}

export default App;
