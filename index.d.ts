export interface IContactInfo {
    /**
     * How long the contact was in proximity. Minimum duration is 5 minutes and increments by 5 minutes: 5, 10, 15, etc.
     * 
     * This value is in seconds.
     */
    duration: number;

    /**
     * This property contains the time when the contact occurred. This may have reduced precision, such as within one day of the actual time.
     * 
     * This value is in seconds since 00:00:00 UTC on 1 January 2001.
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