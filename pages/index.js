import React, { useState, useEffect, useContext } from "react";
import Image from 'next/image';
import Countdown from "react-countdown";

//INTERNAL IMPORT
import { VotingContext } from "../context/Voter";
import Style from '../styles/index.module.css';
import Card from '../components/card/card';
import image from '../assets/candidate-1.jpg';

const index = () => {
  const {
    getNewCandidate,
    candidateArray,
    giveVote,
    currentAccount,
    checkIfWalletIsConnected,
    candidateLength,
    voterLength,
    getAllVoterData,
  } = useContext(VotingContext);

  useEffect(() => {
    checkIfWalletIsConnected();
    getAllVoterData();
  }, []);

  return (
    <div className={Style.home}>{currentAccount && (
      <div className={Style.winner}>
        <div className={Style.winner_info}>
          <div className={Style.candidate_list}>
            <p>
              No Candidate: <span>{candidateLength}</span>
            </p>
          </div>
          <div className={Style.candidate_list}>
            <p>
              No Voter: <span>{voterLength}</span>
            </p>
          </div>
        </div>
        <div className={Style.winner_message}>
          <small>
            <Countdown date={Date.now() + 100000000}/>
          </small>
        </div>
      </div>
    )}
    <Card candidateArray={candidateArray} giveVote={giveVote} />
    </div>
  );

};

export default index;
