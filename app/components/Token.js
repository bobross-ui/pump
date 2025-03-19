import { ethers } from "ethers"

function Token({ toggleTrade, token }) {
  return (
    <button onClick={() => toggleTrade(token)} className="token">
      <div className="token_details">
        <img src={token.image} alt="token image" width={256} height={256}/>
        <p>created by {token.creator.slice(0,6)+'...'+token.creator.slice(38,42)}</p>
        <p>market Cap: {ethers.formatEther(token.raised)} eth</p>
        <p className="name">{token.name}</p>
      </div>
    </button>
  );
}

export default Token;