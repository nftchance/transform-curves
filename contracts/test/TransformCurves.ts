import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Transform Curves", function () {
    async function deployTransformCurveFixture() {
        const [deployer, operator] = await ethers.getSigners();

        const TransformCurve = await ethers.getContractFactory("TransformCurve");
        const transformCurve = await TransformCurve.deploy();

        return { deployer, transformCurve };
    }

    describe("Make sure the magic curve works.", function () {
        it("Should deploy the contract", async function () {
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            expect(transformCurve.address).to.be.properAddress;
        });

        it("Should set the correct owner", async function () {
            const { deployer, transformCurve } = await loadFixture(deployTransformCurveFixture);

            expect(await transformCurve.owner()).to.equal(deployer.address);
        });

        it("Should set curve", async function () {
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            const nonce = 0;
            const N = 15;

            const circles = [{
                radius: 0,
                frequency: 0,
                phase: 0,
            }]

            const [deployer, operator] = await ethers.getSigners();

            const tx = await transformCurve.connect(operator).setCurve(nonce, N, circles);
            const rc = await tx.wait();

            const event = rc.events.find((e: {event: string}) => e.event === "CurveSet");
            const args = event.args;

            const expectedCurveId = '0x14e04a66bf74771820a7400ff6cf065175b3d7eb25805a5bd1633b161af5d101';

            expect(args[0]).to.equal(expectedCurveId);
        });

        it("Should have equidistant points", async() => { 
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            const N = 11;
            const pageLength = N;
            const page = 0;

            const start = 0;
            const end = 50;

            const tx = await transformCurve.getLinearSpace(N, pageLength, page, start, end);

            // get the array of points and format them nicely
            const points = tx.map((point: any) => {
                return [point[0].toNumber(), point[1].toNumber()];
            });

            expect(points).to.deep.equal([
                [ 0, 0 ],  [ 5, 0 ],
                [ 10, 0 ], [ 15, 0 ],
                [ 20, 0 ], [ 25, 0 ],
                [ 30, 0 ], [ 35, 0 ],
                [ 40, 0 ], [ 45, 0 ],
                [ 50, 0 ]
              ]);
        })

        // it("Should get the correct curve", async function () {
        //     const { transformCurve } = await loadFixture(deployTransformCurveFixture);

        //     const radii = [1,1,1];
        //     const frequencies = [1,2,3];
        //     const phases = [0,0,0];

        //     const {x,y} = await transformCurve.getCurve(
        //         radii,
        //         frequencies,
        //         phases
        //     );

        //     // zip coords together
        //     const coords = x.map((x: number, i: number) => [x / 1e18, y[i] / 1e18]);

        //     console.log(coords)
        // });
    });
    
    // instantiate the labor market
    // setup the pay curve
    // simulate the pay curve and yoink all the indexes out
});