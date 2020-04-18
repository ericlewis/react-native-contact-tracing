export interface IContactInfo {
    /**
     * In seconds
     */
    duration: number;

    /**
     * In seconds
     */
    timestamp: number;
}

export interface IExposureSummary {
    matchedKeyCount: number;
    contactInformation: IContactInfo[];
}

export enum ContactTracingStatus {
    UNKNOWN,
    ON,
    OFF
}

export interface IContactTracing {
    getConstants(): { supported: boolean };
    start(): Promise<void>;
    stop(): Promise<void>;
    currentStatus(): Promise<ContactTracingStatus>;
    requestExposureSummary(): Promise<IExposureSummary>;
}

declare const ContactTracing: IContactTracing;

export default ContactTracing;