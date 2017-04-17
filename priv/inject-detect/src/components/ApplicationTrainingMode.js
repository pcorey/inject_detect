import React from "react";
import _ from "lodash";
import { ToggleTrainingModeMutation } from "../graphql";
import { graphql } from "react-apollo";

class ApplicationTrainingMode extends React.Component {

    toggleTrainingMode(e) {
        e.preventDefault();
        this.props.toggleTrainingMode(this.props.application.id);
    }

    render() {
        let { application } = this.props;

        return (
            <div className="ui field">
                <div className="ui toggle checkbox">
                    <input type="checkbox" checked={application.trainingMode} onChange={this.toggleTrainingMode.bind(this)}/>
                    <label>In training mode</label>
                </div>
            </div>
        );
    }

};

const ToggleTrainingMode = graphql(ToggleTrainingModeMutation, {
    props: ({ mutate }) => ({
        toggleTrainingMode: (applicationId) => mutate({
            variables: { applicationId }
        })
    })
});

export default ToggleTrainingMode(ApplicationTrainingMode);
