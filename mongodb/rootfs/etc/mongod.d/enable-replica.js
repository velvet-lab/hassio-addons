eval(process.argv.slice(3)[0]);

const ipAddress = args[0].trim();
const port = args[1].trim();

let status = null;
let isConfigured = false;

try {
    status = rs.status();
    isConfigured = status && status.ok === 1;
} catch {
    // rs.status() will throw an error if the replica set is not initialized
    // this is ok, if no replica set is configured
}

const config = {
    _id: "rs0",
    version: 1,
    members: [
        { _id: 0, host: `${ipAddress}:${port}` }
    ]
}

if (!isConfigured) {
    try {
        print("Enable replica set with config");

        const result = rs.initiate(config);
        if (result && result.ok === 1) {
            print("Replica set initialized successfully");
        } else {
            print("Error initializing replica set");
        }
    } catch (err) {
        throw `Error initializing replica set. (Reason: ${err})`;
    }
} else {
    print("Replica set already initialized");
}