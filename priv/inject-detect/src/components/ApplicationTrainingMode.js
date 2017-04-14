import React from "react";
import _ from "lodash";
import { TurnOffTrainingModeMutation, TurnOnTrainingModeMutation } from "../graphql";
import { graphql } from "react-apollo";

class ApplicationTrainingMode extends React.Component {

    toggleTrainingMode(e) {
        e.preventDefault();
        if (this.props.application.trainingMode) {
            this.props.turnOffTrainingMode(this.props.application.id);
        }
        else {
            this.props.turnOnTrainingMode(this.props.application.id);
        }
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

const TurnOnTrainingMode = graphql(TurnOnTrainingModeMutation, {
    props: ({ mutate }) => ({
        turnOnTrainingMode: (applicationId) => mutate({
            variables: { applicationId }
        })
    })
});

const TurnOffTrainingMode = graphql(TurnOffTrainingModeMutation, {
    props: ({ mutate }) => ({
        turnOffTrainingMode: (applicationId) => mutate({
            variables: { applicationId }
        })
    })
});

export default TurnOnTrainingMode(TurnOffTrainingMode(ApplicationTrainingMode));
