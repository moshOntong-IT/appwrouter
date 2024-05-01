class AppwrouterException extends Error {
  status: number;

  constructor(message: string, status: number) {
    super(message);
    this.status = status;
    this.name = "AppwrouterException";

    // This line is needed to make the instanceof operator work correctly
    Object.setPrototypeOf(this, AppwrouterException.prototype);
  }
}
