import './App.css';
import ApolloClient, { createNetworkInterface } from 'apollo-client';
import React, { Component } from 'react';
import logo from './logo.svg';
import { ApolloProvider, graphql } from 'react-apollo';
import Users from "./Users";
import CurrentUser from "./CurrentUser";

const networkInterface = createNetworkInterface({
    uri: "http://localhost:4000/graphql",
    dataIdFromObject: object => object.id,
    opts: {
        credentials: "include"
    }
});

networkInterface.use([{
    applyMiddleware(req, next) {
        if (!req.options.headers) {
            req.options.headers = {};  // Create the header object if needed.
        }
        let TOKEN = localStorage.getItem("token");
        if (TOKEN) {
            req.options.headers.authorization = `Bearer ${TOKEN}`;
        }
        next();
    }
}]);

networkInterface.useAfter([{
    applyAfterware({ response }, next) {
        console.log(response);
        if (response.status === 403) {
            console.log("Logged out")
            if (client) {
                client.query({
                    query: graphql(`
                        query {
                            current_user {
                                id
                                email
                            }
                        }
                    `)
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
                    <div className="App-header">
                        <img src={logo} className="App-logo" alt="logo" />
                        <h2>Welcome to React</h2>
                        <CurrentUser/>
                    </div>
                    <p className="App-intro">
                        To get started, edit <code>src/App.js</code> and save to reload.
                    </p>
                    <Users/>
                </div>
            </ApolloProvider>
        );
    }
}

export default App;
