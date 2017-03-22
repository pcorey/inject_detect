import './App.css';
import ApolloClient, { createNetworkInterface } from 'apollo-client';
import React, { Component } from 'react';
import logo from './logo.svg';
import { ApolloProvider } from 'react-apollo';
import Users from "./Users";

const networkInterface = createNetworkInterface({
    uri: "http://localhost:4000/graphql"
});

// networkInterface.use([{
//     applyMiddleware(req, next) {
//         if (!req.options.headers) {
//             req.options.headers = {};  // Create the header object if needed.
//         }

//         // Send the login token in the Authorization header
//         req.options.headers.authorization = `Bearer ${TOKEN}`;
//         next();
//     }
// }]);

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
