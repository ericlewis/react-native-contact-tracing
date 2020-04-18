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

export interface IContactTracing {
    getConstants(): { supported: boolean };
    start(): Promise<void>;
    stop(): Promise<void>;
    currentStatus(): Promise<number>;
    requestExposureSummary(): Promise<IExposureSummary>;
}

declare const ContactTracing: IContactTracing;

export default ContactTracing;