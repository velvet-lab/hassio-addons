eval(process.argv.slice(3)[0]);

const ipAddress=  args[0].trim();
const port=  args[1].trim();

let status = null;

try {
    status = rs.status();
} catch (err) {
    // rs.status() will throw an error if the replica set is not initialized
    print("rs.status() error: " + err);
}

const config = {
    _id: "rs0",
    version: 1,
    members: [
        { _id: 0, host: `${ipAddress}:${port}` }
    ]
}

if (!status || status.ok === 0) {
    try {
        printjson({
            ...config,
            message: "Enable replica set with config"
        });

        const result = rs.initiate(config);        
        if (result && result.ok === 1) {
            print("Replica set initialized successfully");
        } else {
            printjson({
                ...result,
                message: "Error initializing replica set"
            });
        }
    } catch (err) {
        printjson({
            message: "Error initializing replica set",
            err
        });
    }
} else {
    print("Replica set already initialized");
}