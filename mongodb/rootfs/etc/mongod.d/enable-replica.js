
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
        { _id: 0, host: "localhost:27017" }
    ]
}

if (!status || status.ok === 0) {
    try {
        printjson({
            ...config,
            message: "Enable replica set with config"
        });

        //const result = rs.initiate(config);
        const result = rs.initiate();
        if (result && result.ok === 1) {
            print("Replica set initialized successfully");
        } else {
            printjson({
                ...result,
                message: "Error initializing replica set"
            });
        }
    } catch (err) {
        printjsong({
            message: "Error initializing replica set",
            err
        });
    }
} else {
    print("Replica set already initialized");
}